export const applyRelationships = (sequelize) => {
  const {
    Company,
    Package,
    PublicCompany,
    Receipt,
    Resident,
    ResidentialBlock,
    Message,
    RateParking,
    ControlParking
  } = sequelize.models;

  // ResidentBlock - Resident
  ResidentialBlock.hasMany(Resident, { foreignKey: "id_conjunto_residencial" });
  Resident.belongsTo(ResidentialBlock, {
    foreignKey: "id_conjunto_residencial",
  });

  // Resident - Package
  Resident.hasMany(Package, { foreignKey: "id_residente" });
  Package.belongsTo(Resident, { foreignKey: "id_residente" });

  // Resident - Receipt
  Resident.hasMany(Receipt, { foreignKey: "id_residente" });
  Receipt.belongsTo(Resident, { foreignKey: "id_residente" });

  // Company - Package
  Company.hasMany(Package, { foreignKey: "id_empresa" });
  Package.belongsTo(Company, { foreignKey: "id_empresa" });

  // PublicCompany - Receipt
  PublicCompany.hasMany(Receipt, { foreignKey: "id_empresa_sp" });
  Receipt.belongsTo(PublicCompany, { foreignKey: "id_empresa_sp" });

  // ResidentialBlock - RateParking
  ResidentialBlock.hasOne(RateParking, { foreignKey: "id_conjunto_residencial" });
  RateParking.belongsTo(ResidentialBlock, { foreignKey: "id_conjunto_residencial" });

  // Resident - Message
  Resident.hasMany(Message, { foreignKey: "id_residente" });
  Message.belongsTo(Resident, { foreignKey: "id_residente" });

  // Resident - ControlParking
  Resident.hasMany(ControlParking, { foreignKey: "id_residente" });
  ControlParking.belongsTo(Resident, { foreignKey: "id_residente" });
};
