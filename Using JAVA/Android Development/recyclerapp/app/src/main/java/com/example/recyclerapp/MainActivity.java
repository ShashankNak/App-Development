package com.example.recyclerapp;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.DividerItemDecoration;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;


import android.os.Bundle;

public class MainActivity extends AppCompatActivity {
    RecyclerView recyclerView;
    contact o1 = new contact(1,"TOMMY","5656568382");
    contact o2 = new contact(3,"ARTHUR","9494939493");
    contact o3 = new contact(4,"JOHNNY","9494939493");
    contact o4 = new contact(5,"ADA","9494939493");
    contact o5 = new contact(2,"POLLY","7898351532");
    contact o6 = new contact(6,"MICHAEL","3585742510");
    contact o7 = new contact(7,"GINA","2435658765");
    contact o8 = new contact(8,"CHARLES","9494939493");
    contact o9 = new contact(9,"RUBY","9494939493");
    contact o10 = new contact(10,"LIZZIE","9494939493");

    contact [] contacts = {o1,o2,o3,o4,o5,o6,o7,o8,o9,o10};
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        CustomAdapter ad = new CustomAdapter(contacts);
        recyclerView.setAdapter(ad);
        recyclerView.addItemDecoration(new DividerItemDecoration(this, DividerItemDecoration.VERTICAL));
    }
}