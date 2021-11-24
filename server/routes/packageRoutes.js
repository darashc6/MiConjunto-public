import express from "express";
import {
  getPackages,
  getResidentsWithPendingPackages,
  addPackage,
  updatePackage
} from "../controllers/packageController.js";

const router = express.Router();

router.get("/", getPackages);
router.get("/pending/residents", getResidentsWithPendingPackages);
router.post("/new", addPackage);
router.patch("/:packageId/update", updatePackage);

export default router;
