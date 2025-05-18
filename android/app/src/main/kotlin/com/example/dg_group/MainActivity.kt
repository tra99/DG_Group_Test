package com.example.dg_group

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.Inet4Address
import java.net.Inet6Address
import java.net.NetworkInterface

class MainActivity: FlutterActivity() {
  private val CHANNEL = "network_info"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      when (call.method) {
        "getIPv4" -> {
          val type = call.argument<Int>("type") ?: 0
          val forceRefresh = call.argument<Boolean>("forceRefresh") ?: false
          val ip = fetchIp(type, preferIPv6 = false)
          result.success(ip)
        }
        "getIPv6" -> {
          val type = call.argument<Int>("type") ?: 0
          val forceRefresh = call.argument<Boolean>("forceRefresh") ?: false
          val ip = fetchIp(type, preferIPv6 = true)
          result.success(ip)
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  private fun fetchIp(type: Int, preferIPv6: Boolean): String {
    // type == 0 => Wi-Fi, type == 1 => Mobile
    val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val network = cm.activeNetwork ?: return "No internet connection"
    val caps = cm.getNetworkCapabilities(network) ?: return "No internet connection"
    val ok = when (type) {
      0 -> caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
      1 -> caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR)
      else -> true
    }
    if (!ok) return "No internet connection"

    return try {
      NetworkInterface.getNetworkInterfaces().toList().flatMap { intf ->
        intf.inetAddresses.toList()
      }.firstOrNull { addr ->
        !addr.isLoopbackAddress &&
        when {
          !preferIPv6 && addr is Inet4Address -> true
          preferIPv6 && addr is Inet6Address -> true
          else -> false
        }
      }?.hostAddress ?: "Unavailable"
    } catch (e: Exception) {
      "Unavailable"
    }
  }
}
