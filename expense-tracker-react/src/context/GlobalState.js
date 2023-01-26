import React, {createContext, useReducer} from 'react';
import AppReducer from './AppReducer';
import api from "../services/api";

// Initial state
const initialState = {
    transactions: [],
    error: null,
    loading: true
}

// Create context
export const GlobalContext = createContext(initialState);

// Provider component
export const GlobalProvider = ({children}) => {
    const [state, dispatch] = useReducer(AppReducer, initialState);

    // Actions
    async function getTransactions() {
        try {
            await api({
                method: 'get',
                url: 'api/v1/transactions',
            })
                .then(function (response) {
                    dispatch({
                        type: 'GET_TRANSACTIONS',
                        payload: response.data
                    });
                });
        } catch (err) {
            dispatch({
                type: 'TRANSACTIONS_ERROR',
                payload: err.response
            });
        }
    }

    async function addTransaction(transaction) {
        try {
            await api({
                method: 'post',
                url: 'api/v1/transactions',
                data: transaction
            })
                .then(function (response) {
                    dispatch({
                        type: 'ADD_TRANSACTION',
                        payload: response.data
                    });
                });
        } catch (err) {
            dispatch({
                type: 'TRANSACTIONS_ERROR',
                payload: err.response
            });
        }
    }

    async function deleteTransaction(id) {
        try {
            await api({
                method: 'delete',
                url: `api/v1/transactions/${id}`,
            })
                .then(function () {
                    dispatch({
                        type: 'DELETE_TRANSACTION',
                        payload: id
                    });
                });
        } catch (err) {
            dispatch({
                type: 'TRANSACTIONS_ERROR',
                payload: err.response
            });
        }
    }

    return (<GlobalContext.Provider value={{
        transactions: state.transactions,
        getTransactions,
        error: state.error,
        loading: state.loading,
        deleteTransaction,
        addTransaction
    }}>
        {children}
    </GlobalContext.Provider>);
}