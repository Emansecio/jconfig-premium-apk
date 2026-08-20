import java.io.*;
import java.nio.file.*;
import java.util.stream.*;

import com.android.tools.smali.dexlib2.Opcodes;
import com.android.tools.smali.dexlib2.writer.builder.DexBuilder;
import com.android.tools.smali.dexlib2.writer.io.FileDataStore;
import brut.androlib.src.SmaliBuilder;

public class Asm {
    public static void main(String[] args) throws Exception {
        File smaliDir = new File(args[0]);
        File out = new File(args[1]);
        int api = args.length > 2 ? Integer.parseInt(args[2]) : 28;
        DexBuilder db = new DexBuilder(new Opcodes(api, 38));
        SmaliBuilder sb = new SmaliBuilder(smaliDir, api);
        final int[] err = {0};
        Files.walk(smaliDir.toPath())
            .filter(p -> p.toString().endsWith(".smali"))
            .sorted()
            .forEach(p -> {
                String rel = smaliDir.toPath().relativize(p).toString().replace('\\', '/');
                try {
                    sb.buildFile(rel, db);
                } catch (Throwable t) {
                    System.out.println("SMALI ERROR in " + rel + ": " + t.getMessage());
                    if (t.getStackTrace().length > 0)
                        System.out.println("  at " + t.getStackTrace()[0]);
                    err[0]++;
                }
            });
        if (err[0] > 0) {
            System.out.println("FAILED with " + err[0] + " errors");
            System.exit(2);
        }
        db.writeTo(new FileDataStore(out));
        System.out.println("DEX OK -> " + out + " (" + out.length() + " bytes)");
    }
}
