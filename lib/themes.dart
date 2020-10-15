import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget title(String texte) {
  return Text(
    texte,
    style: GoogleFonts.lato(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
  );
}
