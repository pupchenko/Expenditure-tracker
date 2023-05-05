import axios from "axios";

const backendUrl = process.env.REACT_APP_BACKEND_URL ? `http://${process.env.REACT_APP_BACKEND_URL}` : 'http://localhost:8080'

const api = axios.create({
        baseURL: backendUrl
    }
)

export default api;