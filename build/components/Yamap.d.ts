import React from 'react';
import { ViewProps, ImageSourcePropType, NativeSyntheticEvent } from 'react-native';
import { Animation, Point, DrivingInfo, MasstransitInfo, RoutesFoundEvent, Vehicles, CameraPosition, FocusRegion, CustomMarker } from '../interfaces';
export interface YaMapProps extends ViewProps {
    userLocationIcon?: ImageSourcePropType;
    showUserPosition?: boolean;
    nightMode?: boolean;
    mapStyle?: string;
    onCameraPositionChange?: (event: NativeSyntheticEvent<CameraPosition>) => void;
    onMapPress?: (event: NativeSyntheticEvent<Point>) => void;
    onMapLongPress?: (event: NativeSyntheticEvent<Point>) => void;
    userLocationAccuracyFillColor?: string;
    userLocationAccuracyStrokeColor?: string;
    userLocationAccuracyStrokeWidth?: number;
}
export declare class YaMap extends React.Component<YaMapProps> {
    static defaultProps: {
        showUserPosition: boolean;
    };
    map: React.RefObject<any>;
    static ALL_MASSTRANSIT_VEHICLES: Vehicles[];
    static init(apiKey: string): void;
    static setLocale(locale: string): Promise<void>;
    static getLocale(): Promise<string>;
    static resetLocale(): Promise<void>;
    findRoutes(points: Point[], vehicles: Vehicles[], callback: (event: RoutesFoundEvent<DrivingInfo | MasstransitInfo>) => void): void;
    findMasstransitRoutes(points: Point[], callback: (event: RoutesFoundEvent<MasstransitInfo>) => void): void;
    findPedestrianRoutes(points: Point[], callback: (event: RoutesFoundEvent<MasstransitInfo>) => void): void;
    findDrivingRoutes(points: Point[], callback: (event: RoutesFoundEvent<DrivingInfo>) => void): void;
    fitAllMarkers(): void;
    setCenter(center: {
        lon: number;
        lat: number;
        zoom?: number;
    }, zoom?: number, azimuth?: number, tilt?: number, duration?: number, animation?: Animation): void;
    setZoom(zoom: number, duration?: number, animation?: Animation): void;
    getCameraPosition(callback: (position: CameraPosition) => void): void;
    getFocusRegion(callback: (focusRegion: FocusRegion) => void): void;
    addMarkers(points: CustomMarker[]): void;
    private _findRoutes;
    private getCommand;
    private processRoute;
    private processCameraPosition;
    private processFocusRegion;
    private resolveImageUri;
    private getProps;
    render(): JSX.Element;
}
