"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const prismaService_1 = __importDefault(require("../services/prismaService"));
const zod_1 = __importDefault(require("zod"));
const validateZod_1 = require("../middleware/validateZod");
const attachUser_1 = require("../middleware/attachUser");
const reviewSchema = zod_1.default.object({
    body: zod_1.default.object({
        review: zod_1.default.string(),
        rating: zod_1.default.number().nullable(),
        project_id: zod_1.default.number(),
    }),
});
function default_1({ app }) {
    app.post("/reviews", (0, validateZod_1.validateZod)(reviewSchema), attachUser_1.attachUser, (req, res) => __awaiter(this, void 0, void 0, function* () {
        try {
            const user = req.user;
            const prismaService = prismaService_1.default.getInstance();
            console.log(user);
            prismaService.client.$transaction([
                prismaService.client.reviews.create({
                    data: {
                        review: req.body.review,
                        rating: req.body.rating,
                        user: {
                            connect: {
                                id: user.id,
                            },
                        },
                        projects: {
                            connect: {
                                id: req.body.project_id,
                            },
                        },
                    },
                }),
                prismaService.client.timeline.create({
                    data: {
                        text: `Review placed by ${user.firstName + " " + user.lastName} (${req.body.rating} Stars)`,
                        project_id: req.body.project_id,
                    },
                }),
            ]);
            res.status(200).send({
                message: "Review created",
            });
        }
        catch (err) {
            console.log(err);
            res.status(500).send({
                message: "Internal server error",
            });
        }
    }));
}
exports.default = default_1;
