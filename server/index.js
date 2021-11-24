import express from "express";
import { sequelize } from "./sequelize/index.js";
import { initFirebaseAdmin } from "./firebase/index.js";
import residentialBlockRoutes from "./routes/residentialBlockRoutes.js";
import residentRoutes from "./routes/residentRoutes.js";
import receiptRoutes from "./routes/receiptRoutes.js";
import packageRoutes from "./routes/packageRoutes.js";
import companyRoutes from "./routes/companyRoutes.js";
import publicCompanyRoutes from "./routes/publicCompanyRoutes.js";
import messageRoutes from "./routes/messageRoutes.js";
import controlParkingRoutes from "./routes/controlParkingRoutes.js";
import rateParkingRoutes from "./routes/rateParkingRoutes.js";
import qrReaderRoutes from "./routes/qrReaderRoutes.js";

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/blocks", residentialBlockRoutes);
app.use("/residents", residentRoutes);
app.use("/packages", packageRoutes);
app.use("/receipts", receiptRoutes);
app.use("/companies", companyRoutes);
app.use("/public_companies", publicCompanyRoutes);
app.use("/messages", messageRoutes);
app.use("/control_parking", controlParkingRoutes);
app.use("/rate_parking", rateParkingRoutes);
app.use("/qr_reader", qrReaderRoutes);

app.get("/", (req, res) => {
  res.send("Hello World");
});

app.listen(process.env.PORT || 5000, async () => {
  try {
    initFirebaseAdmin();
    await sequelize.authenticate();
    console.log("Connection succesful!");
    console.log("Connection to the MySQL database is working!");
    console.log("Models have been synchronized!");
  } catch (error) {
    console.error(
      "Error in the database. Please rectify the error and try again"
    );
    console.error(error);
  }
});
