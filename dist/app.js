"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const user_1 = __importDefault(require("./routes/user"));
const projects_1 = __importDefault(require("./routes/projects"));
const review_1 = __importDefault(require("./routes/review"));
const app = (0, express_1.default)();
// add body parser
app.use(express_1.default.json());
(0, user_1.default)({ app });
(0, projects_1.default)({ app });
(0, review_1.default)({ app });
app.listen(3000, () => {
    console.log("Listening on port 3000");
});
