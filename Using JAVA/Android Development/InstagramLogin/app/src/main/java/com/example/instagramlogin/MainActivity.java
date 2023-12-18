package com.example.instagramlogin;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class MainActivity extends AppCompatActivity {
    EditText username;
    EditText password;

    public static final String EXTRA_USERNAME = "com.example.instagramlogin.extra.USERNAME";
    public static final String EXTRA_PASSWORD = "com.example.instagramlogin.extra.PASSWORD";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }

    public void loginComplete(View view){
        username = findViewById(R.id.editTextTextEmailAddress);
        password = findViewById(R.id.editTextTextPassword);

        String userNameText = username.getText().toString();
        String passwordText = username.getText().toString();

        Intent intent = new Intent(this,MainActivity2.class);
        intent.putExtra(EXTRA_USERNAME,userNameText);
        intent.putExtra(EXTRA_PASSWORD,passwordText);
        startActivity(intent);
    }
}