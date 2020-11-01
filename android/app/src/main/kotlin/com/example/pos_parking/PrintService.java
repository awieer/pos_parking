package com.example.pos_parking;

import android.app.Activity;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import com.example.pos_parking.util.BluetoothUtil;
import com.example.pos_parking.util.ESCUtil;
import com.example.pos_parking.util.SunmiPrintHelper;

import java.io.IOException;

import static com.example.pos_parking.util.BluetoothUtil.*;


public class PrintService extends Activity {

    private int record;
    private boolean isBold, isUnderLine;

    private String[] mStrings = new String[]{"CP437", "CP850", "CP860", "CP863", "CP865", "CP857", "CP737", "Windows-1252", "CP866", "CP852", "CP858", "CP874", "CP855", "CP862", "CP864", "GB18030", "BIG5", "KSC5601", "utf-8"};

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initPrinterStyle();

        Bundle extras = getIntent().getExtras();
        String type = extras.getString("type");

        record = 17;
        isBold = false;
        isUnderLine = false;

        if (!isBlueToothPrinter) {
            printReceipt(type);
        } 
    }

    private void printReceipt(String type){
        Bundle extras = getIntent().getExtras();
        String pbt = extras.getString("pbt");
        String plate = extras.getString("plate");
        String id = extras.getString("id");
        String createdAt = extras.getString("createdAt");
        String name = extras.getString("name");
        String pass = extras.getString("pass");
        String price = extras.getString("price");
        String total = extras.getString("total");
        if(type.equals("parking")){
            SunmiPrintHelper.getInstance().printExample(this, pbt, plate, id, createdAt, name, pass, price);
            SunmiPrintHelper.getInstance().feedPaper();
        }else if(type.equals("kompaun")){
            SunmiPrintHelper.getInstance().printKompaun(this, pbt, plate, id, createdAt, name, pass, price, total);
            SunmiPrintHelper.getInstance().feedPaper();
        }else {
            SunmiPrintHelper.getInstance().printCetak(this, pbt, plate, id, createdAt, name, pass, price, total);
            SunmiPrintHelper.getInstance().feedPaper();
        }
        
        setResult(Activity.RESULT_OK);
        finish();
    }


    private void initPrinterStyle() {
        if(BluetoothUtil.isBlueToothPrinter){
            sendData(ESCUtil.init_printer());
        }else{
            SunmiPrintHelper.getInstance().initPrinter();
        }
    }

    private void printByBluTooth(String content) {
        try {
            if (isBold) {
                sendData(ESCUtil.boldOn());
            } else {
                sendData(ESCUtil.boldOff());
            }

            if (isUnderLine) {
                sendData(ESCUtil.underlineWithOneDotWidthOn());
            } else {
                sendData(ESCUtil.underlineOff());
            }

            if (record < 17) {
                sendData(ESCUtil.singleByte());
                sendData(ESCUtil.setCodeSystemSingle(codeParse(record)));
            } else {
                sendData(ESCUtil.singleByteOff());
                sendData(ESCUtil.setCodeSystem(codeParse(record)));
            }

            sendData(content.getBytes(mStrings[record]));
            sendData(ESCUtil.nextLine(3));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private byte codeParse(int value) {
        byte res = 0x00;
        switch (value) {
            case 0:
                res = 0x00;
                break;
            case 1:
            case 2:
            case 3:
            case 4:
                res = (byte) (value + 1);
                break;
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
            case 11:
                res = (byte) (value + 8);
                break;
            case 12:
                res = 21;
                break;
            case 13:
                res = 33;
                break;
            case 14:
                res = 34;
                break;
            case 15:
                res = 36;
                break;
            case 16:
                res = 37;
                break;
            case 17:
            case 18:
            case 19:
                res = (byte) (value - 17);
                break;
            case 20:
                res = (byte) 0xff;
                break;
            default:
                break;
        }
        return (byte) res;
    }


}