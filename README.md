# OFDM Transceiver

The general idea of this work is the implementation of a complete point-to-point OFDM communication chain including transmitter, channel, and receiver. To do so, the analog bandpass processing has been summarized into a baseband model. This model summarizes all channel and hardware effects that are attributed to bandpass
processing including but not limited to up/down conversion, amplification, antenna patterns, and so on. However, some of the bandpass effects have been included into the work by equivalent baseband descriptions as non-linear hardware.

In addition to the transmitter and receiver implementation, a simulation environment has been created that uses the transmitter and receiver implementations to numerically analyze the performance of the whole multi-point-to-point communication chain.
