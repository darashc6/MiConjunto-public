import DataTypes from "sequelize";

/**
 * Modelo de 'conjunto_residencial' en base de datos
 * @param {*} sequelize 
 */
export const residentialBlockModel = (sequelize) => {
  sequelize.define(
    "ResidentialBlock",
    {
      residentialBlockId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_conjunto_residencial",
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "nombre",
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    },
    {
      tableName: "conjunto_residencial",
      timestamps: false,
    }
  );
};
