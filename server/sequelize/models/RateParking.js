import DataTypes from "sequelize";

/**
 * Modelo de 'tarifa_parqueadero' en base de datos
 * @param {*} sequelize 
 */
export const rateParkingModel = (sequelize) => {
  sequelize.define(
    "RateParking",
    {
      rateParkingId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_tarifa_parqueado",
      },
      secondsFree: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "tiempo_gratis_segundos",
      },
      rateType: { // 'false' -> Tarifa fija. 'true' -> Tarifa por minuto
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true,
        field: "tipo_tarifa"
      },
      rateFixed: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "tarifa_fija",
      },
      ratePerMinute: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "tarifa_por_minuto"
      }
    },
    {
      tableName: "tarifa_parqueado",
      timestamps: false,
    }
  );
};
