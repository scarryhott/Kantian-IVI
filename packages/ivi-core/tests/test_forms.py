from ivi_core.forms import NullForms


def test_null_forms():
    W = NullForms().lapse(context={}).lapse_W
    assert W.shape == (1,)
    assert float(W[0]) == 1.0
