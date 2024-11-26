package com.aifun.dateideas.planadate

import android.content.Context
import android.view.LayoutInflater
import android.widget.Button
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.google.android.gms.ads.nativead.MediaView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_layout, null) as NativeAdView

        with(nativeAdView) {
            val headlineView: TextView = findViewById(R.id.ad_headline)
            val bodyView: TextView = findViewById(R.id.ad_body)
            val callToActionView: Button = findViewById(R.id.ad_call_to_action)
            val mediaView: MediaView = findViewById(R.id.ad_media)

            headlineView.text = nativeAd.headline
            bodyView.text = nativeAd.body
            callToActionView.text = nativeAd.callToAction
            mediaView.setMediaContent(nativeAd.mediaContent)

            this.headlineView = headlineView
            this.bodyView = bodyView
            this.callToActionView = callToActionView
            this.mediaView = mediaView

            this.setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}
