import { sequelize } from "../sequelize/index.js";
import { firebaseApp } from "../firebase/index.js";

const { Message, Resident } = sequelize.models;

/**
 * Devuelve todos los mensajes de un residente
 * 'residentId' -> Obligatorio. ID de residente. Utilizado para filtrar los mensajes
 * @param {*} req 
 * @param {*} res 
 */
export const getMessages = async (req, res) => {
  const { residentId } = req.query;

  try {
    const residentMessages = await Message.findAll({
      where: {
        id_residente: residentId,
      },
      attributes: {
        exclude: ["id_residente"]
      },
      order: [["fecha_envio", "DESC"]],
    });

    if (residentMessages === null)
      throw new Error("Error fetching resident messages");

    res.status(200).json(residentMessages);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Añadir un nuevo mensaje para un residente específico
 * 'residentId' -> Obligatorio. ID del residente. Para determinar a que residente va dirigido el mensaje
 * 'subject' -> Obligatorio. Asunto.
 * 'message' -> Obligatorio. Contenido del mensaje
 * @param {*} req 
 * @param {*} res 
 */
export const addMessage = async (req, res) => {
  const { residentId, subject, message } = req.body;

  try {
    const result = await sequelize.transaction(async (t) => {
      const residentToSend = await Resident.findOne(
        {
          where: {
            id_residente: residentId,
          },
        },
        { transaction: t }
      );

      if (residentToSend === null) throw new Error("Resident does not exist");

      const newMessage = Message.build({
        subject: subject,
        dateSent: Date.now(),
        messageContent: message,
        id_residente: residentId,
      });

      await newMessage.save({ transaction: t });

      if (
        residentToSend.deviceToken !== null &&
        residentToSend.deviceToken.length > 0
      ) {
        const payload = {
          notification: {
            title: "¡Nuevo mensaje!",
            body: "¡Ha recibido un nuevo mensaje por parte del conjunto!",
          },
          data: {
            type: "NEW_MESSAGE",
          },
        };

        await firebaseApp
          .messaging()
          .sendToDevice(residentToSend.deviceToken, payload);
      }

      if (newMessage === null) throw new Error("Error saving message");

      return newMessage;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};

/**
 * Actualiza el estado del mensaje. En concreto, convierte un mensaje de estado 'no leído', en estado 'leído'
 * 'messageId' -> Obligatorio. ID del mensaje a actualizar.
 * @param {*} req 
 * @param {*} res 
 */
export const updateMessage = async (req, res) => {
  const { messageId } = req.params;

  try {
    const result = await sequelize.transaction(async (t) => {
      const messageToUpdate = await Message.findOne(
        {
          where: {
            id_mensaje: messageId,
          },
        },
        { transaction: t }
      );

      if (messageToUpdate === null) throw new Error("Message not found");

      const messageUpdated = await messageToUpdate.update(
        {
          isRead: true,
        },
        { transaction: t }
      );

      return messageUpdated;
    });

    res.status(200).json(result);
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: error.message });
  }
};
