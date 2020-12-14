package ru.vvdev.yamap.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.yandex.mapkit.geometry.Point;
import com.yandex.mapkit.map.MapObject;
import com.yandex.mapkit.map.MapObjectTapListener;
import com.yandex.mapkit.map.PlacemarkMapObject;
import com.yandex.runtime.image.ImageProvider;

import ru.vvdev.yamap.models.ReactMapObject;

public class CustomViewMarker extends ViewGroup implements MapObjectTapListener, ReactMapObject {
    public Point point;
    private PlacemarkMapObject mapObject;
    private int parentId;

    public CustomViewMarker(Context context) {
        super(context);
    }

    @Override
    protected void onLayout(boolean b, int i, int i1, int i2, int i3) {

    }

    private void updateMarker() {
        String text = "1500 р";
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(Color.WHITE);
        paint.setTextSize(50);

        Paint rectPaint = new Paint();
        rectPaint.setTextSize(50);
        rectPaint.setColor(Color.RED);
        Rect bounds = new Rect();
        rectPaint.getTextBounds(text, 0, text.length(), bounds);

        Rect rect = new Rect();
        rect.top = 0;
        rect.left = 0;
        rect.bottom = bounds.height() + 10;
        rect.right = bounds.width() + 10;

        Bitmap b = Bitmap.createBitmap(bounds.width()+10, bounds.height()+10, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(b);

        c.drawRect(rect, rectPaint);
        c.drawText(text,5,bounds.height()+5, paint);

        mapObject.setIcon(ImageProvider.fromBitmap(b));
    }

    public void setMapObject(MapObject obj) {
        mapObject = (PlacemarkMapObject) obj;
        mapObject.addTapListener(this);
        updateMarker();
    }

    public MapObject getMapObject() {
        return mapObject;
    }

    @Override
    public boolean onMapObjectTap(@NonNull MapObject mapObject, @NonNull Point point) {
        WritableMap e = Arguments.createMap();
        e.putString("message", "MyMessage");
        ((ReactContext) getContext()).getJSModule(RCTEventEmitter.class).receiveEvent(parentId, "onMarkerPressed", e);
        return true;
    }

    public void setParentId(int id) {
        parentId = id;
    }
}