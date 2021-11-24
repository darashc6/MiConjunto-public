import DataTypes from "sequelize";

/**
 * Modelo de 'empresa' en base de datos
 * @param {*} sequelize 
 */
export const companyModel = (sequelize) => {
  sequelize.define(
    "Company",
    {
      companyId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_empresa",
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "nombre",
      },
    },
    {
      tableName: "empresa",
      timestamps: false,
    }
  );
};
