# Wavelet LSB Insertion
Steganographic insertion (recovery) into (from) LSBs of DWT coefficients obtained after 5-level filterbank

An implementation of the following research:
Cvejic N, Seppanen T: A wavelet domain, LSB insertion algorithm for high capacity audio steganography,
Proc. 10th IEEE Digital Signal Processing Workshop and 2nd Signal Processing Education Workshop.
(Georgia, USA, 13-16 October, 2002), pp. 53-55

Bit error ratio with respect to scope of insertion is evaluated with averaging over multiple frames.

Since it is a MATLAB project, all you need a MATLAB environment for running these files and adding them “to path”.

launch.m – run this function to launch both insertion and retrieval process and the computation of BER with respect to the scope of insertion. Requires no arguments.

waveletLSBembed.m – function covering the whole insertion process. Requires input samples, data to insert and scope of insertion (start, end). Returns stego samples and the DWT coefficient matrix of last frame in binary format after inserting data.

getQuantizedDwtCoefsMatrix.m – contains the whole analysis phase for one frame.

performIDWT.m – contains the whole synthesis phase for one frame.

waveletLSBretrieve.m – function covering the retrieval. Requires input samples and scope of insertion (start, end). Returns retrieved data and the DWT coefficient matrix of last frame in binary format.

countBitErrors.m – computes bit error ratio based on differences of elements of two uint16 integer arrays.