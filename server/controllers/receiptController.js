import { firebaseApp } from "../firebase/index.js";
import { sequelize } from "../sequelize/index.js";
import Sequelize from "sequelize";

const { Receipt, Resident, PublicCompany, ResidentialBlock } = sequelize.models;
const { Op } = Sequelize;

/**
 * Devuelve todas los recibos de un residente.
 * 'residentId' -> Obligatorio. Es lo que filtra los recibos por cada residente
 * 'showPendingOnly' -> Opcional. Se usa en caso de que solo queramos ver los recibos pendientes
 * @param {*} req
 * @param {*} res
 */
export const getReceipts = async (req, res) => {
  try {
    const { residentId, showPendingOnly } = req.query;

    let whereCondition = {};
    whereCondition.id_residente = residentId;
    whereCondition.fecha_recepcion = {
      [Op.gt]: sequelize.literal("now() - INTERVAL 90 day"),
    };
    showPendingOnly === "true" && (whereCondition.fecha_entrega = null);

    const receipts = await Receipt.findAll({
      attributes: {
        exclude: ["id_residente", "id_empresa_sp"],
      },
      where: whereCondition,
      order: [
        ["fecha_entrega", "DESC"],
        ["fecha_recepcion", "DESC"],
      ],
      include: [
        {
          model: PublicCompany,
        },
      ],
    });

    if (receipts === null) throw new Error("Error fetching resident receipts");

    res.status(200).json(receipts);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Muestra aquellos residentes que tienes alguno(s) recibos(s) pendiente
 * 'residentialBlockId' -> Obligatorio. Para filtrar los residentes por cada conjunto residencial
 * @param {*} req
 * @param {*} res
 */
export const getResidentsWithPendingReceipts = async (req, res) => {
  const { residentialBlockId } = req.query;

  try {
    const residentWithPendingPackages = await Receipt.findAll({
      where: {
        fecha_entrega: null,
      },
      attributes: ["id_residente"],
      group: ["id_residente"],
      include: {
        model: Resident,
        attributes: {
          exclude: ["password", "deviceToken", "webPage"],
        },
        where: {
          id_conjunto_residencial: residentialBlockId,
        },
      },
    });

    if (residentWithPendingPackages === null)
      throw new Error("Error fetching residents With Pending Receipts");

    res.json(residentWithPendingPackages);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Añade un nuevo recibo.
 * 'residentId' -> Obligatorio. ID del residente al que va dirigido el nuevo recibo
 * 'publicCompanyId' -> Obligatorio. ID de la empresa se servicio público.
 * 'notes' -> Opcional. Observaciones del recibo
 * @param {*} req
 * @param {*} res
 */
export const addReceipt = async (req, res) => {
  const { notes, residentId, publicCompanyId } = req.body;

  try {
    const result = await sequelize.transaction(async (t) => {
      const residentToSend = await Resident.findOne({
        where: {
          id_residente: residentId,
        },
      });

      if (residentToSend === null) throw new Error("Resident does not exist");

      const newReceipt = Receipt.build({
        receptionDate: Date.now(),
        notes: notes,
        id_residente: residentToSend.residentId,
        id_empresa_sp: publicCompanyId,
      });

      await newReceipt.save({ transaction: t });

      if (
        residentToSend.deviceToken !== null &&
        residentToSend.deviceToken.length > 0
      ) {
        const payload = {
          notification: {
            title: "¡Nuevo recibo!",
            body: "¡Tiene un nuevo recibo en Porteria por recoger!",
          },
          data: {
            type: "NEW_RECEIPT",
          },
        };

        await firebaseApp
          .messaging()
          .sendToDevice(residentToSend.deviceToken, payload);
      }

      if (newReceipt === null) throw new Error("Error saving receipt");

      return newReceipt;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Actualiza el recibo. Para confirmar la entrega del recibo al residente.
 * 'receiptId' -> Obligatorio. ID del recibo a actualizar
 * @param {*} req
 * @param {*} res
 */
export const updateReceipt = async (req, res) => {
  const { receiptId } = req.params;

  try {
    const result = await sequelize.transaction(async (t) => {
      const receiptToUpdate = await Receipt.findOne(
        {
          where: {
            id_recibo: receiptId,
          },
        },
        { transaction: t }
      );

      if (receiptToUpdate === null) throw new Error("Receipt does not exist");

      const receiptUpdated = await receiptToUpdate.update(
        {
          deliveryDate: Date.now(),
        },
        {
          transaction: t,
        }
      );

      if (receiptUpdated === null) throw new Error("Error updating receipt");

      return receiptUpdated;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
