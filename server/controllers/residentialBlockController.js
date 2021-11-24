import { sequelize } from "../sequelize/index.js";

const { ResidentialBlock } = sequelize.models;

/**
 * Login del conjunto residencial
 * 'email' -> Obligatorio. Email del conjunto residencial
 * 'password' -> Obligatorio. Contraseña del conjunto residencial
 * @param {*} req 
 * @param {*} res 
 */
export const loginResidentialBlock = async (req, res) => {
  const { email, password } = req.body;

  try {
    const residentialBlock = await ResidentialBlock.findOne({
      where: {
        email: email,
        password: password,
      },
      attributes: {
        exclude: ["password"],
      },
    });

    if (residentialBlock === null)
      throw new Error("Residential Block does not exist");

    res.status(200).json(residentialBlock);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
