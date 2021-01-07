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
    private String pointId;
    private String text;

    public interface MarkerTapListener {
        void onMarkerTap(CustomViewMarker marker, Point point);
    }

    private MarkerTapListener markerTapListener;

    public void setMarkerTapListener(MarkerTapListener listener) {
        this.markerTapListener = listener;
    }

    public CustomViewMarker(Context context) {
        super(context);
    }

    @Override
    protected void onLayout(boolean b, int i, int i1, int i2, int i3) {

    }

    public void setPointId(String id) {
        this.pointId = id;
    }

    public String getPointId() {
        return this.pointId;
    }

    public void setText(String text) {
        this.text = text;
    }

    private void updateMarker(boolean active) {
        Typeface typeface = Typeface.createFromAsset(getContext().getAssets(), "fonts/Roboto-Bold.ttf");
        String text = this.text;
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        paint.setColor(Color.WHITE);
        paint.setTextSize(39);
        paint.setTypeface(typeface);

        Paint rectPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        rectPaint.setTextSize(39);
        rectPaint.setColor(active ? Color.RED : Color.BLUE);
        Rect bounds = new Rect();
        rectPaint.getTextBounds(text, 0, text.length(), bounds);

        RectF rect = new RectF(5 ,5, bounds.width() + 35, bounds.height() + 28);
        Bitmap b = Bitmap.createBitmap(bounds.width()+41, bounds.height()+41, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(b);
        rectPaint.setShadowLayer(8, 3, 3, Color.argb(180,0,0,0));
        setLayerType(LAYER_TYPE_SOFTWARE, rectPaint);
        c.drawRoundRect(rect, 15, 15, rectPaint);
        c.drawText(text,17,bounds.height()+10, paint);

        mapObject.setIcon(ImageProvider.fromBitmap(b));
    }

    public void setMapObject(MapObject obj) {
        mapObject = (PlacemarkMapObject) obj;
        mapObject.addTapListener(this);
        updateMarker(false);
    }

    public MapObject getMapObject() {
        return mapObject;
    }


    public void activate() {
        updateMarker(true);
    }

    public void deactivate() {
        updateMarker(false);
    }

    @Override
    public boolean onMapObjectTap(@NonNull MapObject mapObject, @NonNull Point point) {
        markerTapListener.onMarkerTap(this, point);
        WritableMap e = Arguments.createMap();
        e.putDouble("lat", point.getLatitude());
        e.putDouble("lon", point.getLongitude());
        e.putString("id", this.getPointId());
        ((ReactContext) getContext()).getJSModule(RCTEventEmitter.class).receiveEvent(parentId, "onMarkerPressed", e);
        return true;
    }

    public void setParentId(int id) {
        parentId = id;
    }
}