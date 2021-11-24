import express from "express";
import {
  getResidents,
  loginResident,
  saveDeviceToken,
} from "../controllers/residentController.js";

const router = express.Router();

router.get("/", getResidents);
router.post("/login", loginResident);
router.patch("/:residentId/save_token", saveDeviceToken);

export default router;
