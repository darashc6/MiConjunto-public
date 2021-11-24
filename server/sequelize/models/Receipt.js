import DataTypes from "sequelize";

/**
 * Modelo de 'recibo' en base de datos
 * @param {*} sequelize 
 */
export const receiptModel = (sequelize) => {
  sequelize.define(
    "Receipt",
    {
      receiptId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false,
        autoIncrement: true,
        field: "id_recibo",
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
      tableName: "recibo",
      timestamps: false,
    }
  );
};
