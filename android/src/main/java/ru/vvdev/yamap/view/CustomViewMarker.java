package ru.vvdev.yamap.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
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
        Typeface typeface = Typeface.createFromAsset(getContext().getAssets(), "fonts/Roboto-Bold.ttf");
        String text = "2500 р";
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(Color.WHITE);
        paint.setTextSize(45);
        paint.setTypeface(typeface);

        Paint rectPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        rectPaint.setTextSize(50);
        rectPaint.setColor(Color.BLUE);
        Rect bounds = new Rect();
        rectPaint.getTextBounds(text, 0, text.length(), bounds);

        RectF rect = new RectF(5 ,5, bounds.width() + 30, bounds.height() + 30);
        Bitmap b = Bitmap.createBitmap(bounds.width()+41, bounds.height()+41, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(b);
        rectPaint.setShadowLayer(8, 3, 3, Color.argb(180,0,0,0));
        setLayerType(LAYER_TYPE_SOFTWARE, rectPaint);
        c.drawRoundRect(rect, 15, 15, rectPaint);
        c.drawText(text,15,bounds.height()+10, paint);

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