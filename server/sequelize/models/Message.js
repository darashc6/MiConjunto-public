import DataTypes from "sequelize";

/**
 * Modelo de 'mensaje' en base de datos
 * @param {*} sequelize 
 */
export const messageModel = (sequelize) => {
  sequelize.define(
    "Message",
    {
      messageId: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: "id_mensaje",
      },
      subject: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "asunto",
      },
      messageContent: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "mensaje_contenido",
      },
      dateSent: {
        type: DataTypes.DATE,
        allowNull: false,
        field: "fecha_envio"
      },
      isRead: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        field: "leido",
      },
    },
    {
      tableName: "mensaje",
      timestamps: false,
    }
  );
};
