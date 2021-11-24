import DataTypes from "sequelize";

/**
 * Modelo de 'empresa_servicio_publico' en base de datos
 * @param {*} sequelize 
 */
export const publicCompanyModel = (sequelize) => {
  sequelize.define(
    "PublicCompany",
    {
      publicCompanyId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_empresa_sp",
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "nombre",
      },
    },
    {
      tableName: "empresa_servicio_publico",
      timestamps: false,
    }
  );
};
