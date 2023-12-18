package com.example.tictactoe;


import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;

import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Arrays;


public class MainActivity2 extends AppCompatActivity {
    boolean start = false;

    @SuppressLint("SetTextI18n")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main2);
        Intent intent = getIntent();
        String name1 = intent.getStringExtra(MainActivity.EXTRA_NAME1);
        String name2 = intent.getStringExtra(MainActivity.EXTRA_NAME2);

        ImageView replayButton = findViewById(R.id.replayButton);
        ImageView playButton = findViewById(R.id.playButton);
        ImageView backButton = findViewById(R.id.back);
        TextView status = findViewById(R.id.status);
        TextView player1 = findViewById(R.id.player1);
        TextView player2 = findViewById(R.id.player2);

        player1.setText(name1);
        player2.setText(name2);

        status.setText(R.string.startmessage);


        playButton.setOnClickListener(view -> {
            start = true;
            status.setTextColor(getResources().getColor(R.color.white));
            status.setText(name1 +"\'s turn");
            gameReset(view);
        });
        replayButton.setOnClickListener(view -> {
            start = true;
            status.setTextColor(getResources().getColor(R.color.white));
            status.setText(name1 + "\'s turn");
            gameReset(view);
        });
        backButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

    }

    boolean gameActive = true;



    // Player representation
    // 0 - X
    // 1 - O
    int activePlayer = 0;
    int[] gameState = {2, 2, 2, 2, 2, 2, 2, 2, 2};

    // State meanings:
    //    0 - X
    //    1 - O
    //    2 - Null
    // put all win positions in a 2D array
    int[][] winPositions = {{0, 1, 2}, {3, 4, 5}, {6, 7, 8},
            {0, 3, 6}, {1, 4, 7}, {2, 5, 8},
            {0, 4, 8}, {2, 4, 6}};
    public static int counter = 0;

    @SuppressLint("SetTextI18n")
    public void playerTap(View view) {
        Intent intent = getIntent();
        String name1 = intent.getStringExtra(MainActivity.EXTRA_NAME1);
        String name2 = intent.getStringExtra(MainActivity.EXTRA_NAME2);

        ImageView img = (ImageView) view;
        int tappedImage = Integer.parseInt(img.getTag().toString());
        TextView status = findViewById(R.id.status);
        if (start){
            if (!gameActive) {
                gameReset(view);
            }

            if (gameState[tappedImage] == 2) {
                counter++;

                if (counter == 9) {
                    gameActive = false;
                }
                gameState[tappedImage] = activePlayer;

                // this will give a motion effect to the image
                img.setTranslationY(-1000f);

                // change the active player
                // from 0 to 1 or 1 to 0
                if (activePlayer == 0) {
                    // set the image of x
                    img.setImageResource(R.drawable.x);
                    activePlayer = 1;
                    // change the status
                    status.setText(name2 +"\'s turn");
                } else {
                    // set the image of o
                    img.setImageResource(R.drawable.o);
                    activePlayer = 0;
                    // change the status
                    status.setText(name1+"\'s turn");
                }
                img.animate().translationYBy(1000f).setDuration(300);
            }
            // Check if any player has won
            for (int[] winPosition : winPositions) {
                if (gameState[winPosition[0]] == gameState[winPosition[1]] &&
                        gameState[winPosition[1]] == gameState[winPosition[2]] &&
                        gameState[winPosition[0]] != 2) {

                    // Somebody has won! - Find out who!
                    String winnerStr;

                    // game reset function be called
                    gameActive = false;
                    if (gameState[winPosition[0]] == 0) {
                        winnerStr = name1 +" won";


                    } else {
                        winnerStr = name2 +" won";
                    }
                    status.setTextColor(getResources().getColor(R.color.high));
                    status.setText(winnerStr);
                    counter = 0;
                    start = false;
                }
            }
            // set the status if the match draw
            if (counter == 9) {
                status.setTextColor(getResources().getColor(R.color.red));
                status.setText("Match Draw");
                start = false;
            }
        }
        else{
            status.setTextColor(getResources().getColor(R.color.white));
            status.setText("Press Play or Restart");
        }
    }

    // reset the game
    public void gameReset(View view) {
        gameActive = true;
        activePlayer = 0;
        Arrays.fill(gameState, 2);
        // remove all the images from the boxes inside the grid
        ((ImageView) findViewById(R.id.imageView0)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView1)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView2)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView3)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView4)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView5)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView6)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView7)).setImageResource(0);
        ((ImageView) findViewById(R.id.imageView8)).setImageResource(0);
    }
}