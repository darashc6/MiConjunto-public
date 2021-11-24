import { sequelize } from "../sequelize/index.js";
import { firebaseApp } from "../firebase/index.js";
import Sequelize from "sequelize";

const { Package, Resident, Company, ResidentialBlock } = sequelize.models;
const { Op } = Sequelize;

/**
 * Devuelve todas las encomiendas de un residente.
 * 'residentId' -> Obligatorio. Es lo que filtra las encomiendas por cada residente
 * 'showPendingOnly' -> Opcional. Se usa en caso de que solo queramos ver las encomiendas pendientes
 * @param {*} req
 * @param {*} res
 */
export const getPackages = async (req, res) => {
  try {
    const { residentId, showPendingOnly } = req.query;

    let whereCondition = {};
    whereCondition.id_residente = residentId;
    whereCondition.fecha_recepcion = {
      [Op.gt]: sequelize.literal("now() - INTERVAL 90 day"),
    };
    showPendingOnly === "true" && (whereCondition.fecha_entrega = null);

    const packages = await Package.findAll({
      attributes: {
        exclude: ["id_residente", "id_empresa"],
      },
      order: [
        ["fecha_recepcion", "DESC"],
        ["fecha_entrega", "DESC"],
      ],
      where: whereCondition,
      include: [
        {
          model: Company,
        },
      ],
    });

    if (packages === null) throw new Error("Error fetching packages");

    res.status(200).json(packages);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Muestra aquellos residentes que tienes alguna(s) encomienda(s) pendiente
 * 'residentialBlockId' -> Obligatorio. Para filtrar los residentes por cada conjunto residencial
 * @param {*} req
 * @param {*} res
 */
export const getResidentsWithPendingPackages = async (req, res) => {
  const { residentialBlockId } = req.query;

  try {
    const residentWithPendingPackages = await Package.findAll({
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
      throw new Error("Error fetching residents with pending packages");

    res.status(200).json(residentWithPendingPackages);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Añade una nueva encomienda.
 * 'residentId' -> Obligatorio. ID del residente al que va dirigido la nueva encomienda
 * 'companyId' -> Obligatorio. ID de la empresa.
 * 'notes' -> Opcional. Observaciones de la encomienda
 * @param {*} req
 * @param {*} res
 */
export const addPackage = async (req, res) => {
  const { notes, residentId, companyId } = req.body;

  try {
    const result = await sequelize.transaction(async (t) => {
      const residentToSend = await Resident.findOne(
        {
          where: {
            id_residente: residentId,
          },
        },
        { transaction: t }
      );

      if (residentToSend === null) throw new Error("Resident does not exist");

      const newPackage = Package.build({
        receptionDate: Date.now(),
        notes: notes,
        id_residente: residentToSend.residentId,
        id_empresa: companyId,
      });

      await newPackage.save({ transaction: t });

      if (
        residentToSend.deviceToken !== null &&
        residentToSend.deviceToken.length > 0
      ) {
        const payload = {
          notification: {
            title: "¡Nueva encomienda!",
            body: "¡Tiene una nueva encomienda en Porteria por recoger!",
          },
          data: {
            type: "NEW_PACKAGE",
          },
        };

        await firebaseApp
          .messaging()
          .sendToDevice(residentToSend.deviceToken, payload);
      }

      if (newPackage === null) throw new Error("Error saving package")

      return newPackage;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};

/**
 * Actualiza la encomienda. Para confirmar la entrega de la encomienda al residente.
 * 'packageId' -> Obligatorio. ID de la encomienda a actualizar
 * @param {*} req
 * @param {*} res
 */
export const updatePackage = async (req, res) => {
  const { packageId } = req.params;

  try {
    const result = await sequelize.transaction(async (t) => {
      const packageToUpdate = await Package.findOne(
        {
          where: {
            id_encomienda: packageId,
          },
        },
        { transaction: t }
      );

      if (packageToUpdate === null) throw new Error("Package does not exist");

      const packageUpdated = await packageToUpdate.update(
        {
          deliveryDate: Date.now(),
        },
        { transaction: t }
      );

      if (packageUpdated === null) throw new Error("Error updating package");

      return packageUpdated;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};
