import { BehaviorSubject } from 'rxjs';
import getConfig from 'next/config';
import Router from 'next/router';
import axios from "axios";
import Cookie from "js-cookie";
import { fetchWrapper } from 'helpers';

const { publicRuntimeConfig } = getConfig();
const baseUrl = `${publicRuntimeConfig.apiUrl}/users`;
const userSubject = new BehaviorSubject(process.browser && JSON.parse(localStorage.getItem('user')));

export const userService = {
    // user: userSubject.asObservable(),
    // get userValue() { return userSubject.value },
    login,
    logout,
    checkAuthentication,
};

const axiosApiCall = (url, method, body = {}) =>
    axios({
        method,
        url: `${publicRuntimeConfig.apiUrl}/${url}`,
        data: body,
    }).then(user => { });

function login(username, password) {
    return axios({
        method: "post",
        url: `http://localhost:3001/auth/login`,
        data: { username, password },
    }).then(res => {
        // publish user to subscribers and store in local storage to stay logged in between page refreshes
        // userSubject.next(user);
        // localStorage.setItem('user', JSON.stringify(user));

        Cookie.set("user", JSON.stringify(res.data.user));
        Cookie.set("accesstoken", res.data.access_token);

        return user;
    });
}

function logout() {
    // remove user from local storage, publish null to user subscribers and redirect to login page
    localStorage.removeItem('user');
    userSubject.next(null);
    Router.push('/account/login');
}

function register(user) {
    return fetchWrapper.post(`${baseUrl}/register`, user);
}

function getAll() {
    return fetchWrapper.get(baseUrl);
}

function getById(id) {
    return fetchWrapper.get(`${baseUrl}/${id}`);
}

function update(id, params) {
    return fetchWrapper.put(`${baseUrl}/${id}`, params)
        .then(x => {
            // update stored user if the logged in user updated their own record
            if (id === userSubject.value.id) {
                // update local storage
                const user = { ...userSubject.value, ...params };
                localStorage.setItem('user', JSON.stringify(user));

                // publish updated user to subscribers
                userSubject.next(user);
            }
            return x;
        });
}

function checkAuthentication(){
   const user =  Cookie.get("user");
   const access_token  = Cookie.get("accesstoken");
    console.log("access token ",access_token );
}

