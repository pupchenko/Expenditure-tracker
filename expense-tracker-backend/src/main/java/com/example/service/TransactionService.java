package com.example.service;

import com.example.model.Transaction;

import java.util.List;

public interface TransactionService {
    List<Transaction> getTransactions();

    Transaction save(Transaction transaction);

    void delete(long id);
}

