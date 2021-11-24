import Sequelize from "sequelize";
import { dbConfig } from "../db/config.js";
import { companyModel } from "./models/Company.js";
import { packageModel } from "./models/Package.js";
import { publicCompanyModel } from "./models/PublicCompany.js";
import { receiptModel } from "./models/Receipt.js";
import { residentModel } from "./models/Resident.js";
import { residentialBlockModel } from "./models/ResidentialBlock.js";
import { messageModel } from "./models/Message.js";
import { rateParkingModel } from "./models/RateParking.js";
import { controlParkingModel } from "./models/ControlParking.js";
import { QrReaderModel } from "./models/QrReader.js";
import { applyRelationships } from "./relationships.js";

const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  { host: dbConfig.host, dialect: dbConfig.dialect }
);

companyModel(sequelize);
packageModel(sequelize);
publicCompanyModel(sequelize);
receiptModel(sequelize);
residentModel(sequelize);
residentialBlockModel(sequelize);
messageModel(sequelize);
rateParkingModel(sequelize);
controlParkingModel(sequelize);
QrReaderModel(sequelize);

applyRelationships(sequelize);

export { sequelize };
