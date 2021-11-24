import { sequelize } from "../sequelize/index.js";
import { firebaseApp } from "../firebase/index.js";
import Sequelize from "sequelize";

const { ControlParking, Resident, RateParking } = sequelize.models;
const { Op } = Sequelize;

/**
 * Muestra aquellos residentes que tiene algun parqueamiento activo
 * 'residentialBlockId' -> Obligatorio. ID del conjunto. Para filtrar los residentes por cada conjunto residencial
 * @param {*} req
 * @param {*} res
 */
export const getResidentsWithControlParking = async (req, res) => {
  const { residentialBlockId } = req.query;

  try {
    const residentsWithParking = await ControlParking.findAll({
      where: {
        fecha_salida: null,
      },
      attributes: ["id_residente"],
      group: ["id_residente"],
      include: {
        model: Resident,
        attributes: {
          exclude: ["email", "password", "deviceToken", "webPage"],
        },
        where: {
          id_conjunto_residencial: residentialBlockId,
        },
      },
    });

    if (residentsWithParking === null)
      throw new Error("Error fetching residents with control parking");

    res.status(200).json(residentsWithParking);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Devuelve datos del parqueamiento del residente indicado
 * 'residentId' -> Obligatorio. ID del residente. Para filtrar el parqueamiento
 * @param {*} req
 * @param {*} res
 */
export const getControlParking = async (req, res) => {
  const { residentId } = req.query;

  try {
    const residentControlParking = await ControlParking.findOne({
      where: {
        id_residente: residentId,
        fecha_salida: null,
      },
      attributes: {
        exclude: ["id_residente"],
      },
    });

    if (residentControlParking === null)
      throw new Error("Error fetching resident's control parking");

    res.status(200).json(residentControlParking);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Muestra el historial de todos los parqueamientos de un residente específico.
 * 'residentId' -> Obligatorio. ID del residente. Para filtrar el historial
 * @param {*} req
 * @param {*} res
 */
export const getListControlParking = async (req, res) => {
  const { residentId } = req.query;

  try {
    const residentControlParking = await ControlParking.findAll({
      where: {
        id_residente: residentId,
        fecha_salida: {
          [Op.not]: null,
        },
      },
      order: [["fecha_salida", "DESC"]],
      attributes: {
        exclude: ["id_residente"],
      },
    });

    if (residentControlParking === null)
      throw new Error("Error fetching resident's control parking");

    res.status(200).json(residentControlParking);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Añadir un nuevo parqueamiento.
 * 'nParking' -> Obligatorio. Nº del parqueamiento.
 * 'numberPlate' -> Obligatorio. Placa del vehículo
 * 'residentId' -> Obligatorio. ID del residente
 * 'notes  -> Opcional. Observaciones acerca del parqueamiento
 * @param {*} req
 * @param {*} res
 */
export const addControlParking = async (req, res) => {
  const { nParking, numberPlate, notes, residentId } = req.body;

  try {
    const result = await sequelize.transaction(async (t) => {
      const residentToFind = await Resident.findOne(
        {
          where: {
            id_residente: residentId,
            parqueado_activo: "0",
          },
        },
        { transaction: t }
      );

      if (residentToFind === null)
        throw new Error(
          "Resident does not exist / Resident already has an active parking spot"
        );

      const newControlParking = ControlParking.build({
        nParking: nParking,
        entryDate: Date.now(),
        numberPlate: numberPlate,
        notes: notes,
        id_residente: residentId,
      });

      await newControlParking.save({ transaction: t });
      await residentToFind.update(
        {
          parkingActive: true,
        },
        { transaction: t }
      );

      if (
        residentToFind.deviceToken !== null &&
        residentToFind.deviceToken.length > 0
      ) {
        const payload = {
          notification: {
            title: "¡Nuevo parqueadero!",
            body: "¡Se le ha asignado un parqueadero al visitante!",
          },
          data: {
            type: "NEW_PARKING",
          },
        };

        await firebaseApp
          .messaging()
          .sendToDevice(residentToFind.deviceToken, payload);
      }

      return newControlParking;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Actualiza el estado del parqueamiento.
 * 'controlParkingId' -> Obligatorio. ID del parqueamiento a actualizar.
 * @param {} req
 * @param {*} res
 */
export const updateControlParking = async (req, res) => {
  const { controlParkingId } = req.params;

  try {
    const result = await sequelize.transaction(async (t) => {
      const controlParkingToUpdate = await ControlParking.findOne(
        {
          where: {
            id_control_parqueadero: controlParkingId,
            fecha_salida: null,
          },
        },
        { transaction: t }
      );

      if (controlParkingToUpdate === null)
        throw new Error(
          "ControlParking does not exist / ControlParking already updated"
        );

      const residentToUpdate = await Resident.findOne(
        {
          where: {
            id_residente: controlParkingToUpdate.id_residente,
            parqueado_activo: "1",
          },
        },
        { transaction: t }
      );

      if (residentToUpdate === null)
        throw new Error(
          "Resident does not exist / Resident does not have an active parking spot"
        );

      const rateParkingToApply = await RateParking.findOne(
        {
          where: {
            id_conjunto_residencial: residentToUpdate.id_conjunto_residencial,
          },
        },
        { transaction: t }
      );

      if (rateParkingToApply === null)
        throw new Error("RateParking does not exist");

      let exitDate = Date.now();
      let chargingRate = 0;
      let timeDiffInSeconds = Math.floor(
        (exitDate - Date.parse(controlParkingToUpdate.entryDate)) / 1000
      );

      if (timeDiffInSeconds > rateParkingToApply.secondsFree) {
        if (rateParkingToApply.rateType === false) {
          chargingRate = rateParkingToApply.rateFixed;
        } else {
          let timePast = Math.ceil((timeDiffInSeconds - rateParkingToApply.secondsFree) / 60);
          chargingRate = rateParkingToApply.ratePerMinute * timePast;
        }
      }

      const controlParkingUpdated = await controlParkingToUpdate.update(
        {
          exitDate: exitDate,
          chargingRate: chargingRate,
        },
        { transaction: t }
      );

      await residentToUpdate.update(
        {
          parkingActive: false,
        },
        { transaction: t }
      );

      return controlParkingUpdated;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
