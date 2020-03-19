//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

package com.airnmap.backdrop_geo

import com.airnmap.backdrop_geo.data.*
import com.squareup.moshi.Moshi

object Codec {

  private val moshi: Moshi = Moshi.Builder()
      .add(Permission.Adapter())
      .add(Priority.Adapter())
      .add(LocationUpdatesRequest.Strategy.Adapter())
      .build()

  fun encodeResult(result: Result): String =
      moshi.adapter(Result::class.java).toJson(result)

  fun decodeInt(arguments: Any?): Int =
      arguments!! as Int

  fun decodePermission(arguments: Any?): Permission =
      Permission.Adapter().fromJson(arguments!! as String)

  fun decodeLocationUpdatesRequest(arguments: Any?): LocationUpdatesRequest =
      moshi.adapter(LocationUpdatesRequest::class.java).fromJson(arguments!! as String)!!

  fun decodePermissionRequest(arguments: Any?): PermissionRequest =
      moshi.adapter(PermissionRequest::class.java).fromJson(arguments!! as String)!!

}
