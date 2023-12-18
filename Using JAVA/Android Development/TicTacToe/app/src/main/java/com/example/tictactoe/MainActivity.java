package com.example.tictactoe;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class MainActivity extends AppCompatActivity {
    public static final String EXTRA_NAME1 = "com.example.tictactoe.extra.NAME1";
    public static final String EXTRA_NAME2 = "com.example.tictactoe.extra.NAME2";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void openActivity(View view){
        Intent intent1 =  new Intent(this, MainActivity2.class);
        EditText player1 = findViewById(R.id.player1Name);
        EditText player2 = findViewById(R.id.player2Name);

        String Name1 = player1.getText().toString();
        String Name2 = player2.getText().toString();

        intent1.putExtra(EXTRA_NAME1,Name1);
        intent1.putExtra(EXTRA_NAME2,Name2);
        startActivity(intent1);
        player1.setText("");
        player2.setText("");
    }
}

