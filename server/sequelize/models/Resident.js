import DataTypes from "sequelize";

/**
 * Modelo de 'residente' en base de datos
 * @param {*} sequelize 
 */
export const residentModel = (sequelize) => {
  sequelize.define(
    "Resident",
    {
      residentId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_residente",
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      tower: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "torre",
      },
      apartment: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: "apartamento",
      },
      phoneNumber1: {
        type: DataTypes.STRING,
        field: "telefono1",
      },
      phoneNumber2: {
        type: DataTypes.STRING,
        field: "telefono2",
      },
      phoneNumber3: {
        type: DataTypes.STRING,
        field: "telefono3",
      },
      ownerName: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "nombre_propietario",
      },
      parkingActive: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        field: "parqueado_activo"
      },
      deviceToken: {
        type: DataTypes.STRING,
        field: "token_dispositivo"
      },
      webPage: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "",
        field: "pagina_web"
      }
    },
    {
      tableName: "residente",
      timestamps: false,
    }
  );
};
