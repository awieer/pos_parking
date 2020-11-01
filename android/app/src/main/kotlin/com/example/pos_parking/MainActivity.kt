package com.example.pos_parking

import android.content.Intent
import androidx.annotation.NonNull
import com.example.pos_parking.util.SunmiPrintHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    companion object {
        const val CHANNEL = "com.posparking.channel"
        const val KOMPAUN_NATIVE = "kompaunnative"
        const val PARKIR_NATIVE = "parkirnative"
        const val CETAK_NATIVE = "cetaknative"
        private const val REQUEST_RESULT = 1
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        initFlutterChannel();
        init()
    }

    private fun init() {
        SunmiPrintHelper.getInstance().initSunmiPrinterService(this)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        val channel = MethodChannel(getFlutterEngine()?.getDartExecutor()?.getBinaryMessenger(), CHANNEL)
        if (requestCode == REQUEST_RESULT && resultCode == RESULT_OK) {
            print("Success");
            channel.invokeMethod("message", "success")
        }
    }

    private fun initFlutterChannel() {
        val channel = MethodChannel(getFlutterEngine()?.getDartExecutor()?.getBinaryMessenger(), CHANNEL)
        channel.setMethodCallHandler { methodCall, result ->
            val args = methodCall.arguments as List<*>

            if (methodCall.method == KOMPAUN_NATIVE) {
                val pbt = args.first() as String
                val plate = args[1] as String
                val id = args[2] as String
                val createdAt = args[3] as String
                val name = args[4] as String
                val pass = args[5] as String
                val price = args[6] as String
                val total = args[7] as String

                val intent = Intent(this, PrintService::class.java)

                intent.putExtra("pbt", pbt);
                intent.putExtra("plate", plate);
                intent.putExtra("id", id);
                intent.putExtra("createdAt", createdAt);
                intent.putExtra("name", name);
                intent.putExtra("pass", pass);
                intent.putExtra("price", price);
                intent.putExtra("total", total);
                intent.putExtra("type", "kompaun");


                startActivityForResult(intent, REQUEST_RESULT)
                result.success(true)
            } else if (methodCall.method == CETAK_NATIVE) {
                val pbt = args.first() as String
                val plate = args[1] as String
                val id = args[2] as String
                val createdAt = args[3] as String
                val name = args[4] as String
                val pass = args[5] as String
                val price = args[6] as String
                val total = args[7] as String

                val intent = Intent(this, PrintService::class.java)

                intent.putExtra("pbt", pbt);
                intent.putExtra("plate", plate);
                intent.putExtra("id", id);
                intent.putExtra("createdAt", createdAt);
                intent.putExtra("name", name);
                intent.putExtra("pass", pass);
                intent.putExtra("price", price);
                intent.putExtra("total", total);
                intent.putExtra("type", "cetak");


                startActivityForResult(intent, REQUEST_RESULT)
                result.success(true)
            } else if(methodCall.method == PARKIR_NATIVE) {

                val pbt = args.first() as String
                val plate = args[1] as String
                val id = args[2] as String
                val createdAt = args[3] as String
                val name = args[4] as String
                val pass = args[5] as String
                val price = args[6] as String

                val intent = Intent(this, PrintService::class.java)

                intent.putExtra("pbt", pbt);
                intent.putExtra("plate", plate);
                intent.putExtra("id", id);
                intent.putExtra("createdAt", createdAt);
                intent.putExtra("name", name);
                intent.putExtra("pass", pass);
                intent.putExtra("price", price);
                intent.putExtra("total", "");
                intent.putExtra("type", "parking");



                startActivityForResult(intent, REQUEST_RESULT)
                result.success(true)
            } else {
                result.notImplemented()
            }

        }
    }

}
