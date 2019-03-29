---
title: 链表题
date: 2019-03-29 15:50:18
tags: [alg]
categories: [算法备忘]
---
### 2. Add Two Numbers
{% note %}
Input: (2 -> 4 -> 3) + (5 -> 6 -> 4)
Output: 7 -> 0 -> 8
Explanation: 342 + 465 = 807.
{% endnote %}

```java
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    ListNode c1 = l1;
    ListNode c2 = l2;
    ListNode sentinel = new ListNode(0);
    ListNode d = sentinel;
    int sum = 0;
    while (c1 != null || c2 != null) {
        sum /= 10;
        if (c1 != null) {
            sum += c1.val;
            c1 = c1.next;
        }
        if (c2 != null) {
            sum += c2.val;
            c2 = c2.next;
        }
        d.next = new ListNode(sum % 10);
        d = d.next;
    }
    if (sum / 10 == 1)
        d.next = new ListNode(1);
    return sentinel.next;
}
```
