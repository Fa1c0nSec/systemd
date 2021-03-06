/* SPDX-License-Identifier: LGPL-2.1+
 * Copyright © 2019 VMware, Inc. */
#pragma once

#include <linux/pkt_sched.h>

#include "time-util.h"

int tc_time_to_tick(usec_t t, uint32_t *ret);
int parse_tc_percent(const char *s, uint32_t *percent);
int tc_transmit_time(uint64_t rate, uint32_t size, uint32_t *ret);
int tc_fill_ratespec_and_table(struct tc_ratespec *rate, uint32_t *rtab, uint32_t mtu);
