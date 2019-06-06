import { writable } from "svelte/store";
import queryString from "query-string";
import About from "./About.svelte";
import Gallery from "./Gallery.svelte";
import MapView from "./Map.svelte"

const routes = {
    "/about": About,
    "/map": MapView,
    "/galleries": Gallery,
    "/location": Location,
    "*": MapView
}

export const parseLocation = () => {
    const parsed = queryString.parse(location.search);

    if (typeof parsed.route == "undefined") {
        parsed.route = "*" // aka: not found
    }

    if (routes.hasOwnProperty(parsed.route)) {
        parsed.view = routes[parsed.route]
    } else {
        parsed.view = routes["*"]
    }

    return parsed
}

export const route = writable(parseLocation());

export const navigate = (loc, data) => {
    if (data == null) {
        data = { route: loc }
    } else {
        data.route = loc
    }

    if (routes.hasOwnProperty(data.route)) {
        data.view = routes[data.route]
    } else {
        data.view = routes["*"]
    }

    console.log(data)
    route.set(data)
    history.pushState(data,"Virtual Tour", loc)

} 
