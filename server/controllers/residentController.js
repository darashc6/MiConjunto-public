import { sequelize } from "../sequelize/index.js";
import Sequelize from "sequelize";

const { Resident, ResidentialBlock } = sequelize.models;
const { Op } = Sequelize;

/**
 * Login del residente
 * 'email' -> Obligatorio. Email del residente.
 * 'password' -> Obligatorio. Contraseña del residente.
 * @param {*} req
 * @param {*} res
 */
export const loginResident = async (req, res) => {
  const { email, password } = req.body;

  try {
    const resident = await Resident.findOne({
      attributes: {
        exclude: ["id_conjunto_residencial", "password"],
      },
      where: {
        email: email,
        password: password,
      },
      include: [
        {
          model: ResidentialBlock,
          attributes: {
            exclude: ["password"],
          },
        },
      ],
    });

    if (resident === null) throw new Error("Resident not found");

    res.status(200).json(resident);
  } catch (error) {
    console.error(error);
    res.status(404).json({ message: error.message });
  }
};

/**
 * Devuelve todos los residentes de un conjunto
 * 'residentialBlockId' -> Obligatorio. ID del conjunto
 * 'tower' -> Opcional. Interior/Torre. Principalmente usado para filtros de busqueda
 * 'apartment' -> Opcional. Apartamento/Casa. Principalmente usado para filtros de busqueda
 * 'ownerName' -> Opcional. Nombre del propietario. Principalmente usado para filtros de busqueda
 * @param {*} req
 * @param {*} res
 */
export const getResidents = async (req, res) => {
  const { residentialBlockId, tower, apartment, ownerName, parkingActive } =
    req.query;

  try {
    let whereCondition = {};
    whereCondition.id_conjunto_residencial = residentialBlockId;
    tower !== undefined &&
      (whereCondition.torre = {
        [Op.eq]: tower,
      });
    apartment !== undefined &&
      (whereCondition.apartamento = { [Op.eq]: apartment });
    ownerName !== undefined &&
      (whereCondition.ownerName = { [Op.substring]: ownerName });
    parkingActive !== undefined &&
      (whereCondition.parkingActive = parkingActive === "true" ? "1" : "0");

    const blockResidents = await Resident.findAll({
      where: whereCondition,
      attributes: {
        exclude: ["email", "password", "deviceToken", "webPage"],
      },
    });

    if (blockResidents === null)
      throw new Error("Error fetching block residents");

    res.status(200).json(blockResidents);
  } catch (error) {
    console.error(error);
    res.status(404).json({});
  }
};

/**
 * Guarda el token de dispositivo móvil del residente en la base de datos
 * 'residentId' -> Obligatorio. ID del residente
 * 'deviceToken' -> Obligatorio. Token del dispositivo que se va a guardar
 * @param {*} req
 * @param {*} res
 */
export const saveDeviceToken = async (req, res) => {
  const { residentId } = req.params;
  const { deviceToken } = req.body;

  try {
    const result = await sequelize.transaction(async (t) => {
      const residentToUpdate = await Resident.findOne(
        {
          where: {
            id_residente: residentId,
          },
          attributes: {
            exclude: ["password", "id_conjunto_residencial"],
          },
          include: {
            model: ResidentialBlock,
            attributes: {
              exclude: ["email", "password"],
            },
          },
        },
        { transaction: t }
      );

      if (residentToUpdate === null) throw new Error("Resident does not exist");

      const updatedResident = await residentToUpdate.update(
        {
          deviceToken: deviceToken,
        },
        { transaction: t }
      );

      if (updatedResident === null)
        throw new Error("Error saving device token to database");

      return updatedResident;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
