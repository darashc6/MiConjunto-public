import DataTypes from "sequelize";


/**
 * Modelo de 'lector_qr' en la base de datos.
 * @param {} sequelize 
 */
export const QrReaderModel = (sequelize) => {
    sequelize.define(
        "QrReader",
        {
            qrReaderId: {
                type: DataTypes.INTEGER,
                primaryKey: true,
                autoIncrement: true,
                field: "id_lector_qr"
            },
            readDate: {
                type: DataTypes.DATE,
                allowNull: false,
                field: "fecha_lectura"
            },
            dataRead: {
                type: DataTypes.STRING,
                allowNull: false,
                field: "dato_leido"
            }
        },
        {
            tableName: "lector_qr",
            timestamps: false,
        }
    )
}