import { sequelize } from "../sequelize/index.js";

const { PublicCompany } = sequelize.models;

/**
 * Devuelve todas las empresas de servicios públicos de recibos
 * @param {*} req 
 * @param {*} res 
 */
export const getPublicCompanies = async (req, res) => {
  try {
    const publicCompanies = await PublicCompany.findAll({});
    res.status(200).json(publicCompanies);
  } catch (error) {
    console.error(error);
    res.status(400).json({ error: error.message });
  }
};
