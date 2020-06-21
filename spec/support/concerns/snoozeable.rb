RSpec.shared_examples 'snoozeable' do |factory:|
  describe '.snoozed' do
    let!(:snoozed) { create factory, snooze_until: Time.zone.now + 1.day }
    let!(:previously_snoozed) { create factory, snooze_until: Time.zone.now - 1.day }
    let!(:not_snoozed) { create factory, snooze_until: nil }

    it 'returns only snoozed items' do
      expect(described_class.snoozed.pluck(:id)).to match_array([snoozed.id])
    end
  end

  describe '.not_snoozed' do
    let!(:snoozed) { create factory, snooze_until: Time.zone.now + 1.day }
    let!(:previously_snoozed) { create factory, snooze_until: Time.zone.now - 1.day }
    let!(:not_snoozed) { create factory, snooze_until: nil }

    it 'returns only non-snoozed items' do
      expect(described_class.not_snoozed.pluck(:id)).to match_array([not_snoozed.id, previously_snoozed.id])
    end
  end

  describe '#snooze' do
    subject { create factory, snooze_until: nil }
    let(:snooze_until) { Time.zone.now + 1.day }

    context 'snoozing and unsnoozing' do
      it 'snoozes the model when passed a valid datetime' do
        result = nil
        expect { result = subject.snooze(until_time: snooze_until) }
          .to change(subject, :snooze_until).from(nil).to(snooze_until.change({ hour: 9, minute: 0 }))
          .and change(subject.activity_logs, :count).by(1)

        expect(result).to eq(true)
        expect(subject.activity_logs.last.action).to eq('snoozed')
      end

      it 'unsnoozes the model when passed nil' do
        subject = create factory, snooze_until: snooze_until
        result = nil
        expect { result = subject.snooze(until_time: nil) }
          .to change(subject, :snooze_until).from(snooze_until).to(nil)
          .and change(subject.activity_logs, :count).by(1)

        expect(result).to eq(true)
        expect(subject.activity_logs.last.action).to eq('unsnoozed')
      end
    end

    context 'invalid state and arguments' do
      it 'does nothing and returns false when passed a time in the past' do
        result = nil
        expect { result = subject.snooze(until_time: Time.zone.now - 1.day) }
          .not_to change(subject.activity_logs, :count)

        expect(result).to eq(false)
        expect(subject.reload.snooze_until).to be_nil
      end

      it 'does nothing and returns false when not snoozeable' do
        allow(subject).to receive(:snoozeable?).and_return(false)
        expect(subject.snooze(until_time: snooze_until)).to eq(false)
      end
    end
  end

  describe '#snoozed?' do
    it 'returns true when snooze_until is set to a future time' do
      subject.snooze_until = Time.zone.now + 1.day
      expect(subject).to be_snoozed
    end

    it 'returns false when snooze_until is not set' do
      subject.snooze_until = nil
      expect(subject).not_to be_snoozed
    end

    it 'returns false when snooze_until is set to a past time' do
      subject.snooze_until = Time.zone.now - 1.day
      expect(subject).not_to be_snoozed
    end
  end
end
