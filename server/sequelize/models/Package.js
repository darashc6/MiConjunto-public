import DataTypes from "sequelize";

/**
 * Modelo de 'encomienda' en base de datos
 * @param {*} sequelize 
 */
export const packageModel = (sequelize) => {
  sequelize.define(
    "Package",
    {
      packageId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false,
        autoIncrement: true,
        field: "id_encomienda",
      },
      receptionDate: {
        type: DataTypes.DATE,
        allowNull: false,
        field: "fecha_recepcion",
      },
      deliveryDate: {
        type: DataTypes.DATE,
        field: "fecha_entrega",
      },
      notes: {
        type: DataTypes.STRING,
        field: "observaciones",
      },
    },
    {
      tableName: "encomienda",
      timestamps: false,
    }
  );
};
