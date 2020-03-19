package com.airnmap.backdrop_geo

import android.annotation.TargetApi
import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.annotation.NonNull
import com.airnmap.backdrop_geo.location.LocationClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

@TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
public class BackdropGeoPlugin : FlutterPlugin, ActivityAware, Application.ActivityLifecycleCallbacks {

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = BackdropGeoPlugin()
      register(instance, registrar.activeContext(), registrar.messenger())

      instance.locationClient.activity = registrar.activity()

      registrar.addRequestPermissionsResultListener(instance.locationClient.permissionResultListener)
      registrar.addActivityResultListener(instance.locationClient.activityResultListener)
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
        registrar.activity().application.registerActivityLifecycleCallbacks(instance)
      }
    }

    private fun register(instance: BackdropGeoPlugin, context: Context, binaryMessenger: BinaryMessenger) {
      instance.locationClient = LocationClient(context)
      instance.handler = Handler(instance.locationClient)

      val methodChannel = MethodChannel(binaryMessenger, "backdrop_geo/location")
      val eventChannel = EventChannel(binaryMessenger, "backdrop_geo/locationUpdates")

      methodChannel.setMethodCallHandler(instance.handler)
      eventChannel.setStreamHandler(instance.handler)
    }
  }

  private lateinit var locationClient: LocationClient
  private lateinit var handler: Handler
  private var activityBinding: ActivityPluginBinding? = null

  private fun attachToActivity(binding: ActivityPluginBinding) {
    if (activityBinding != null) {
      detachFromActivity()
    }
    activityBinding = binding

    locationClient.activity = binding.activity

    binding.addRequestPermissionsResultListener(locationClient.permissionResultListener)
    binding.addActivityResultListener(locationClient.activityResultListener)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
      binding.activity.application.registerActivityLifecycleCallbacks(this)
    }
  }

  private fun detachFromActivity() {
    val binding = activityBinding ?: return

    locationClient.activity = null

    binding.removeRequestPermissionsResultListener(locationClient.permissionResultListener)
    binding.removeActivityResultListener(locationClient.activityResultListener)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
      binding.activity.application.unregisterActivityLifecycleCallbacks(this)
    }

    activityBinding = null
  }


  // FlutterPlugin

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    register(this, flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }


  // ActivityAware

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    attachToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    detachFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }


  // Application.ActivityLifecycleCallbacks

  override fun onActivityPaused(activity: Activity?) {
    locationClient.pause()
  }

  override fun onActivityResumed(activity: Activity?) {
    locationClient.resume()
  }

  override fun onActivityStarted(activity: Activity?) {

  }

  override fun onActivityDestroyed(activity: Activity?) {

  }

  override fun onActivitySaveInstanceState(activity: Activity?, outState: Bundle?) {

  }

  override fun onActivityStopped(activity: Activity?) {

  }

  override fun onActivityCreated(activity: Activity?, savedInstanceState: Bundle?) {

  }


  object Intents {
    const val LocationPermissionRequestId = 12234
    const val LocationPermissionSettingsRequestId = 12230
    const val EnableLocationSettingsRequestId = 12237
  }
}
