import { sequelize } from "../sequelize/index.js";

const { RateParking } = sequelize.models;

/**
 * Devuelve la tarifa del parqueado de un conjunto
 * 'residentialBlockId' -> Obligatorio. ID del conjunto residencial
 * @param {*} req 
 * @param {*} res 
 */
export const getRateParking = async (req, res) => {
  const { residentialBlockId } = req.query;

  try {
    const residentialRateParking = await RateParking.findOne({
      where: {
        id_conjunto_residencial: residentialBlockId,
      },
    });

    if (residentialRateParking === null)
      throw new Error("Error fetching residential parking rates");

    res.status(200).json(residentialRateParking);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
