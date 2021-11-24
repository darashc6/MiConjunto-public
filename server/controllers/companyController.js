import { sequelize } from "../sequelize/index.js";

const { Company } = sequelize.models;

/**
 * Devuelve todas las empresas de encomiendas
 * @param {*} req 
 * @param {*} res 
 */
export const getCompanies = async (req, res) => {
  try {
    const companies = await Company.findAll({});
    res.status(200).json(companies);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
