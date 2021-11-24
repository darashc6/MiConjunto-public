import { sequelize } from "../sequelize/index.js";

const { QrReader } = sequelize.models;

/**
 * Lee los datos que ha recibido del lector de QR.
 * 'data' -> Obligatorio. Dato(s) que ha leido del lector QR.
 * @param {*} req 
 * @param {*} res 
 */
export const readData = async (req, res) => {
    const { data } = req.body;

    try {
        const result = await sequelize.transaction(async (t) => {
            const newQrRead = QrReader.build({
                readDate: Date.now(),
                dataRead: data
            });

            await newQrRead.save({ transaction: t });

            return newQrRead;
        });

        res.status(200).json(result);
    } catch (error) {
        console.error(error);
        res.status(400).json({ error: error.message });
    }
}