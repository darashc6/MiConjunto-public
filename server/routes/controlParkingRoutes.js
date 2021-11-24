import express from "express";
import {
  getResidentsWithControlParking,
  getControlParking,
  getListControlParking,
  addControlParking,
  updateControlParking,
} from "../controllers/controlParkingController.js";

const router = express.Router();

router.get("/", getControlParking);
router.get("/residents", getResidentsWithControlParking);
router.get("/history", getListControlParking);
router.post("/new", addControlParking);
router.patch("/:controlParkingId/update", updateControlParking);

export default router;
