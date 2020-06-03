package com.example.testproject;

import android.annotation.SuppressLint;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity implements ViewPager.OnPageChangeListener {
    private ImageButton buttonMinus;
    private TextView textViewCount;
    private ArrayList<Fragment> fragmentArrayList;
    private ViewPager viewPager;
    private PagerAdapter pagerAdapter;
    public static final String APP_PREFERENCES = "Setting";
    public SharedPreferences sharedPreferences;
    @SuppressLint("StaticFieldLeak")
    public static Context currentContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        fragmentArrayList = new ArrayList<>();
        viewPager = findViewById(R.id.viewPager);
        buttonMinus = findViewById(R.id.button_minus);

        sharedPreferences = getSharedPreferences(APP_PREFERENCES, Context.MODE_PRIVATE);
        textViewCount = findViewById(R.id.textViewCount);

        if(sharedPreferences.getInt("size", 0) > 1) {
            fragmentArrayList.clear();
            for(int i = 1; i <= sharedPreferences.getInt("size", 1); i++){
                fragmentArrayList.add(new CreateNotificationFragment(i));
                viewPager.setCurrentItem(sharedPreferences.getInt("id", 0));
            }
            buttonMinus.setVisibility(View.VISIBLE);
        } else {
            fragmentArrayList.add(new CreateNotificationFragment(0));
            buttonMinus.setVisibility(View.INVISIBLE);
        }
        textViewCount.setText(String.valueOf(fragmentArrayList.size()));
        pagerAdapter = new AdapterPager(super.getSupportFragmentManager());
        ((AdapterPager) pagerAdapter).setFragmentArrayList(fragmentArrayList);

        viewPager.setAdapter(pagerAdapter);
        viewPager.setOnPageChangeListener(this);
    }


    public void buttonClickPlus(View view) {
        if (fragmentArrayList.size() > 0) buttonMinus.setVisibility(View.VISIBLE);
        fragmentArrayList.add(new CreateNotificationFragment(fragmentArrayList.size() + 1));
        textViewCount.setText(String.valueOf(fragmentArrayList.size()));
        ((AdapterPager) pagerAdapter).setFragmentArrayList(fragmentArrayList);
        viewPager.setAdapter(pagerAdapter);
        viewPager.setCurrentItem(fragmentArrayList.size() - 1);
    }

    public void buttonClickMinus(View view) {
        NotificationManager notificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancel(fragmentArrayList.size());
        fragmentArrayList.remove(fragmentArrayList.size() - 1);
        if (fragmentArrayList.size() == 1) buttonMinus.setVisibility(View.INVISIBLE);
        textViewCount.setText(String.valueOf(fragmentArrayList.size()));
        ((AdapterPager) pagerAdapter).setFragmentArrayList(fragmentArrayList);
        viewPager.setAdapter(pagerAdapter);
        viewPager.setCurrentItem(fragmentArrayList.size() - 1, true);
    }

    @Override
    protected void onStop() {
        super.onStop();
        System.out.println("onStop: " + fragmentArrayList.size() + " id: " + viewPager.getCurrentItem());
        sharedPreferences.edit().clear().apply();
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt("size", fragmentArrayList.size());
        editor.putInt("id", viewPager.getCurrentItem());
        editor.apply();
    }

    @Override
    protected void onPause() {
        super.onPause();
        System.out.println("onPause: " + fragmentArrayList.size() + " id: " + viewPager.getCurrentItem());
        sharedPreferences.edit().clear().apply();
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putInt("size", fragmentArrayList.size());
        editor.putInt("id", viewPager.getCurrentItem());
        editor.apply();
    }

    @Override
    protected void onResume() {
        super.onResume();
        currentContext = this;
        if (this.getIntent().getExtras() != null ) {
            System.out.println("R index: " + this.getIntent().getExtras().getInt("index"));
            viewPager.setCurrentItem(getIntent().getExtras().getInt("index"));
        } else {
            System.out.println("Fuck");
        }
    }

//    @Override
//    protected void onDestroy() {
//        super.onDestroy();
//        System.out.println("onDestroy");
//        sharedPreferences.edit().clear().apply();
//    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        textViewCount.setText(String.valueOf(++position));
    }

    @Override
    public vo