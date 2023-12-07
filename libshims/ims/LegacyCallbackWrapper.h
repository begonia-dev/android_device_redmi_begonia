#pragma once

using namespace android;

namespace {
class LegacyCallbackWrapper : public AudioTrack::IAudioTrackCallback {
  const AudioTrack::legacy_callback_t mCallback;
  void *const mData;

public:
  LegacyCallbackWrapper(AudioTrack::legacy_callback_t callback, void *user)
      : mCallback(callback), mData(user) {}
  size_t onMoreData(const AudioTrack::Buffer &buffer) override {
    AudioTrack::Buffer copy = buffer;
    mCallback(AudioTrack::EVENT_MORE_DATA, mData, static_cast<void *>(&copy));
    return copy.size();
  }
  void onUnderrun() override {
    mCallback(AudioTrack::EVENT_UNDERRUN, mData, nullptr);
  }
  void onLoopEnd(int32_t loopsRemaining) override {
    mCallback(AudioTrack::EVENT_LOOP_END, mData, &loopsRemaining);
  }
  void onMarker(uint32_t markerPosition) override {
    mCallback(AudioTrack::EVENT_MARKER, mData, &markerPosition);
  }
  void onNewPos(uint32_t newPos) override {
    mCallback(AudioTrack::EVENT_NEW_POS, mData, &newPos);
  }
  void onBufferEnd() override {
    mCallback(AudioTrack::EVENT_BUFFER_END, mData, nullptr);
  }
  void onNewIAudioTrack() override {
    mCallback(AudioTrack::EVENT_NEW_IAUDIOTRACK, mData, nullptr);
  }
  void onStreamEnd() override {
    mCallback(AudioTrack::EVENT_STREAM_END, mData, nullptr);
  }
  size_t onCanWriteMoreData(const AudioTrack::Buffer &buffer) override {
    AudioTrack::Buffer copy = buffer;
    mCallback(AudioTrack::EVENT_CAN_WRITE_MORE_DATA, mData,
              static_cast<void *>(&copy));
    return copy.size();
  }
};

} // namespace
