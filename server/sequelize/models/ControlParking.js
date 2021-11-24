import DataTypes from "sequelize";

/**
 * Modelo de 'control_parqueadero' en base de datos
 * @param {*} sequelize 
 */
export const controlParkingModel = (sequelize) => {
  sequelize.define(
    "ControlParking",
    {
      controlParkingId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_control_parqueadero",
      },
      entryDate: {
        type: DataTypes.DATE,
        allowNull: false,
        field: "fecha_ingreso",
      },
      exitDate: {
        type: DataTypes.DATE,
        field: "fecha_salida",
      },
      nParking: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "n_parqueado",
      },
      numberPlate: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "placa_vehiculo",
      },
      notes: {
        type: DataTypes.STRING,
        field: "observaciones",
      },
      chargingRate: {
        type: DataTypes.INTEGER,
        field: "tarifa_cobro",
      },
    },
    {
      tableName: "control_parqueadero",
      timestamps: false,
    }
  );
};
